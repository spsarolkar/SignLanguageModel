import CoreML

final class CoreMLDataSource {
    func loadModel(named name: String) throws -> MLModel {
        let config = MLModelConfiguration()
        config.computeUnits = .cpuAndGPU
        return try MLModel(contentsOf: Bundle.main.url(forResource: name, withExtension: "mlmodelc")!)
    }
}
