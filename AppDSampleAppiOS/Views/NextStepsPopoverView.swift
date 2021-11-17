//
//  NextStepsPopoverView.swift
//  AppDSampleAppiOS

import Foundation
import SwiftUI

final class NextStepsPopoverViewController: UIHostingController<NextStepsPopoverView> {
    
    var instructions: String = "" {
        didSet {
            rootView.instructions = instructions
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: NextStepsPopoverView())
        rootView.dismiss = dismiss
        rootView.instructions = instructions
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

struct NextStepsPopoverView: View {
    
    var dismiss: (() -> Void)?

    @Environment(\.presentationMode) var mode

    var instructions =
    """
     Here are the next steps.
    """
    
    var body: some View {
        VStack {
            VStack {
                Button(action: {
                    if let dismiss: (() -> Void) = self.dismiss {
                        dismiss()
                    }
                }, label: {
                    Text("Dismiss")
                }).padding()
            }
            VStack(alignment: .leading) {
                Text("Next Steps")
                    .bold()
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                ScrollView(.vertical, showsIndicators: true) {
                    Text(instructions)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.top, 5)
                }
                Spacer()
            }
        }
    }
}

struct NextStepsPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        NextStepsPopoverView(instructions: "placeholder next steps")
    }
}
