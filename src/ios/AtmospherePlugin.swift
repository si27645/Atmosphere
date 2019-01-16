    @objc(AtmospherePlugin) class AtmospherePlugin : CDVPlugin {
        
        /*
         @objc(echo:)
         func echo(command: CDVInvokedUrlCommand) {
         var pluginResult = CDVPluginResult(
         status: CDVCommandStatus_ERROR
         )
         
         if #available(iOS 11.0, *) {
         let mainController = AtmospherePDFViewer() as UIViewController
         
         self.viewController?.present(
         mainController,
         animated: true,
         completion: nil
         )
         
         } else {
         // Fallback on earlier versions
         }
         
         let msg = command.arguments[0] as? String ?? ""
         
         if msg.characters.count > 0 {
         
         pluginResult = CDVPluginResult(
         status: CDVCommandStatus_OK,
         messageAs: msg
         )
         }
         
         self.commandDelegate!.send(
         pluginResult,
         callbackId: command.callbackId
         )
         }
         */
        
        
        
        @objc(showExternalWebView:)
        func showExternalWebView(command: CDVInvokedUrlCommand) {
            var pluginResult = CDVPluginResult(
                status: CDVCommandStatus_ERROR
            )
            
            if #available(iOS 11.0, *) {
                
                
                if(command.arguments.count > 1){
                    let firstArgument = command.arguments[0] as? String ?? ""
                    let secondArgument = command.arguments[1] as? String ?? ""
                    
                    let mainController = AtmosphereExternalWebView() as AtmosphereExternalWebView
                    
                    mainController.urlLoading = firstArgument
                    mainController.pageTitle = secondArgument
                    
                    self.viewController?.present(
                        mainController,
                        animated: true,
                        completion: nil
                    )
                }
            } else {
                // Fallback on earlier versions
            }
            
            
        }
    }
