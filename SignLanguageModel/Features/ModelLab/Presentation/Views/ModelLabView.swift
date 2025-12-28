import SwiftUI
import Combine

struct ModelLabView: View {
    @StateObject private var viewModel = ModelLabViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Model Lab")
                    .font(.largeTitle)
                    .bold()

                // Training status section
                GroupBox("Training Status") {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Epoch:")
                            Text("\(viewModel.currentEpoch)")
                                .bold()
                        }

                        HStack {
                            Text("Training Loss:")
                            Text(String(format: "%.4f", viewModel.trainingLoss))
                                .bold()
                        }

                        HStack {
                            Text("Validation Accuracy:")
                            Text(String(format: "%.2f%%", viewModel.validationAccuracy * 100))
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Training controls
                HStack(spacing: 15) {
                    Button(action: {
                        Task {
                            await viewModel.startTraining()
                        }
                    }) {
                        Label("Start Training", systemImage: "play.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isTraining)

                    Button(action: {
                        viewModel.stopTraining()
                    }) {
                        Label("Stop Training", systemImage: "stop.fill")
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.isTraining)
                }
            }
            .padding()
        }
        .navigationTitle("Model Lab")
    }
}