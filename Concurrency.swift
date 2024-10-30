//#####   并发  Concurrency   #####//
// 异步代码可以被挂起并在稍后恢复，尽管同一时间只有一段代码在执行。

//   定义和调用异步函数   Defining and Calling Asynchronous Functions


// 为了表示一个函数或方法是异步的，在其声明中参数之后写上 async 关键字
func listPhotos(inGallery name: String) async -> [String] {
    let result =  // ... 一些异步网络代码 ...
    return result
}


// 调用异步方法时，执行会挂起，直到该方法返回。
// 在调用前面写上 await，以标记可能的挂起点。
let photoNames = await listPhotos(inGallery: "Summer Vacation") // 挂起
let sortedNames = photoNames.sorted()
let name = sortedNames[0]
let photo = await downloadPhoto(named: name)  // 挂起
show(photo)


// 通过调用 Task.yield() 方法显式插入一个挂起点。
func generateSlideshow(forGallery gallery: String) async {
    let photos = await listPhotos(inGallery: gallery)
    for photo in photos {
        // ... 为这张照片渲染几秒的视频 ...
        await Task.yield()
    }
}

// 既是异步的又是抛出错误的
func listPhotos(inGallery name: String) async throws -> [String] {
    try await Task.sleep(for: .seconds(2))
    return ["IMG001", "IMG99", "IMG0404"]
}
let photos = try await listPhotos(inGallery: "A Rainy Weekend")
//  需要同时写上 try 和 await



// 异步序列   Asynchronous Sequences

import Foundation

let handle = FileHandle.standardInput
for try await line in handle.bytes.lines {
    print(line)
}



// 尽管下载是异步的，允许其他工作在下载过程中进行，
// 但每次只有一个 downloadPhoto(named:) 调用在运行。
// 每张照片完全下载后，下一张才会开始下载
let firstPhoto = await downloadPhoto(named: photoNames[0])
let secondPhoto = await downloadPhoto(named: photoNames[1])
let thirdPhoto = await downloadPhoto(named: photoNames[2])
let photos = [firstPhoto, secondPhoto, thirdPhoto]
show(photos)



// 要调用异步函数并让它与周围的代码并行运行，
// 可以在定义常量时在 let 前加上 async，
// 然后在每次使用常量时写上 await
async let firstPhoto = downloadPhoto(named: photoNames[0])
async let secondPhoto = downloadPhoto(named: photoNames[1])
async let thirdPhoto = downloadPhoto(named: photoNames[2])

let photos = await [firstPhoto, secondPhoto, thirdPhoto]
show(photos)


//   任务与任务组  Tasks and Task Groups
// 任务（Task）是可以作为程序一部分异步运行的工作单元

// 任务之间有层级关系。
// 同一个任务组中的每个任务共享相同的父任务，而每个任务都可以有子任务。
// 由于任务和任务组之间的显式关系，这种方法被称为结构化并发（Structured Concurrency）。

// 创建了一个新的任务组，然后创建子任务来下载图库中的每张照片
let photos = await withTaskGroup(of: Data.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        group.addTask {
            return await downloadPhoto(named: name)
        }
    }

    var results: [Data] = []
    for await photo in group {
        results.append(photo)
    }

    return results
}


//  任务取消  Task Cancellation  
// Swift 的并发采用协作式取消模型，
// 即每个任务在执行的适当点检查自己是否已被取消，并在被取消时做出相应的响应。

// 响应取消通常意味着以下几种操作之一：
// 抛出 CancellationError 错误。
// 返回 nil 或空集合。
// 返回部分已完成的工作。

let photos = await withTaskGroup(of: Optional<Data>.self) { group in
    let photoNames = await listPhotos(inGallery: "Summer Vacation")
    for name in photoNames {
        // 每个任务通过 TaskGroup.addTaskUnlessCancelled(priority:operation:) 方法添加，
        // 避免在任务取消后开始新的工作
        let added = group.addTaskUnlessCancelled {
            guard !Task.isCancelled else { return nil }
            return await downloadPhoto(named: name)
        }
        guard added else { break }
    }

    var results: [Data] = []
    for await photo in group {
        if let photo { results.append(photo) }
    }
    return results
}

// 对于需要立即收到取消通知的工作，
// 可以使用 Task.withTaskCancellationHandler(operation:onCancel:isolation:) 方法
let task = await Task.withTaskCancellationHandler {
    // 执行任务内容
} onCancel: {
    print("已取消!")
}

// 一段时间后...
task.cancel()  // 输出 "已取消!"

//  非结构化并发  Unstructured Concurrency


//    Actor   //
// Actor 允许并发代码安全地共享信息
// Actor 是一种引用类型，因此 Actor 和类的区别也涉及值类型和引用类型的不同。
// Actor 每次只允许一个任务访问其可变状态，这使得多个任务中的代码可以安全地访问同一个 Actor 实例。

// 使用 actor 关键字引入 Actor，后跟大括号内的定义。
actor TemperatureLogger {
    let label: String
    var measurements: [Int]
    private(set) var max: Int

    init(label: String, measurement: Int) {
        self.label = label
        self.measurements = [measurement]
        self.max = measurement
    }
}

let logger = TemperatureLogger(label: "Outdoors", measurement: 25)
print(await logger.max)
// 输出 "25"
// 访问 logger.max 是一个可能的挂起点。因为 Actor 每次只允许一个任务访问其可变状态，
// 因此如果另一个任务中的代码已经在与 logger 交互，那么当前代码会暂停，等待访问该属性。

// 任务和 Actor 允许将程序划分为可以安全并发运行的部分。
// 在任务或 Actor 实例内部，包含可变状态的部分（例如变量和属性）被称为并发域。
//  Sendable 类型     Sendable Types   // 


// 通常情况下，以下三种类型的类型可以是 Sendable 的：
// 值类型：其可变状态由其他 Sendable 数据组成。例如，一个存储属性是 Sendable 的结构体或关联值是 Sendable 的枚举。
// 没有可变状态的类型：其不可变状态由其他 Sendable 数据组成。例如，一个只有只读属性的结构体或类。
// 包含确保可变状态安全的代码的类型：例如，标记为 @MainActor 的类，或者一个在特定线程或队列上序列化其属性访问的类。
struct TemperatureReading: Sendable {
    var measurement: Int
}

extension TemperatureLogger {
    func addReading(from reading: TemperatureReading) {
        measurements.append(reading.measurement)
    }
}

let logger = TemperatureLogger(label: "Tea kettle", measurement: 85)
let reading = TemperatureReading(measurement: 45)
await logger.addReading(from: reading)
