import UIKit
import WebKit

class AtmosphereExternalWebView: UIViewController, WKNavigationDelegate {
    
    var urlLoading : String?
    var pageTitle : String?
    
    var webView : WKWebView?
    var buttonBack, buttonForward: UIButton!
    var progressView: UIProgressView!
    
    
    let colorButtonsEnable = UIColor(red: CGFloat(26.0/255.0), green: CGFloat(26.0/255.0), blue: CGFloat(26.0/255.0), alpha: CGFloat(1.0))
    let colorButtonsDisable = UIColor(red: CGFloat(204.0/255.0), green: CGFloat(204.0/255.0), blue: CGFloat(204.0/255.0), alpha: CGFloat(1.0))
    
    var toolBar = UIView()
    var bottomBar = UIView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Navigation bar
        //UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().barStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        view.backgroundColor = UIColor(red: CGFloat(110.0/255.0), green: CGFloat(165.0/255.0), blue: CGFloat(20.0/255.0), alpha: CGFloat(1.0))
        
        createToolbar()
        createBottomBar()
        
        let url = URL(string: urlLoading ?? "")
        
        let request = URLRequest.init(url: url!)
        webView = WKWebView(frame: self.view.frame)
        webView?.load(request)
        
        webView?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
        
        webView?.navigationDelegate = self
        webView?.backgroundColor = UIColor(red: CGFloat(51.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(51.0/255.0), alpha: CGFloat(1.0))
        
        self.view.addSubview(webView!)
        
        //if #available(iOS 11.0, *) {
        //let safeGuide = self.view.safeAreaLayoutGuide
        
        
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        webView?.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        webView?.topAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        //} else {
        // Fallback on earlier versions
        //}
        
        refreshButtonsState()
        
    }
    
    @objc func buttonWebViewRefresh(sender: UIButton!){
        webView?.reload()
    }
    
    @objc func buttonWebViewBack(sender: UIButton!){
        if (webView?.canGoBack) != nil{
            webView?.goBack()
        }
    }
    
    
    @objc func buttonWebViewForward(sender: UIButton!){
        if (webView?.canGoForward) != nil{
            webView?.goForward()
        }
    }
    
    
    @objc func buttonClicked(sender: UIButton!){
        
        
        let someText:String = "Hello want to share text also"
        let objectsToShare:URL = URL(string: urlLoading ?? "")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    func createBottomBar(){
        bottomBar.backgroundColor = UIColor(red: CGFloat(229.0/255.0), green: CGFloat(229.0/255.0), blue: CGFloat(233.0/255.0), alpha: CGFloat(1.0))
        self.view.addSubview(bottomBar)
        
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        buttonBack = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 20))
        buttonBack.setImage(UIImage(named: "icon-webview-left.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonBack.tintColor = colorButtonsEnable
        
        buttonBack.addTarget(self, action: #selector(buttonWebViewBack), for: .touchUpInside)
        
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(buttonBack)
        
        
        buttonBack.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 20).isActive = true
        buttonBack.heightAnchor.constraint(equalTo: bottomBar.heightAnchor, constant: -20).isActive = true
        buttonBack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonBack.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        buttonBack.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        createButton(buttonBack)
        
        
        
        
        buttonForward = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        buttonForward.setImage(UIImage(named: "icon-webview-right.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonForward.tintColor = colorButtonsEnable
        
        buttonForward.addTarget(self, action: #selector(buttonWebViewForward), for: .touchUpInside)
        
        
        buttonForward.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(buttonForward)
        
        buttonForward.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonForward.leadingAnchor.constraint(equalTo: buttonBack.trailingAnchor, constant: 20).isActive = true
        buttonForward.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        buttonForward.heightAnchor.constraint(equalTo: bottomBar.heightAnchor, constant: -20).isActive = true
        buttonForward.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        createButton(buttonForward)
        
        
        let buttonRefresh:UIButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        buttonRefresh.setImage(UIImage(named: "icon-webview-refresh.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        buttonRefresh.tintColor = colorButtonsEnable
        
        buttonRefresh.addTarget(self, action: #selector(buttonWebViewRefresh), for: .touchUpInside)
        
        buttonRefresh.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(buttonRefresh)
        
        
        buttonRefresh.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        buttonRefresh.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonRefresh.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor).isActive = true
        buttonRefresh.heightAnchor.constraint(equalTo: bottomBar.heightAnchor, constant: -20).isActive = true
        buttonRefresh.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
        
        createButton(buttonRefresh)
        
        
        progressView = UIProgressView(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        progressView.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.addSubview(progressView)
        
        
        progressView.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 0).isActive = true
        progressView.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: 0).isActive = true
        progressView.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 0).isActive = true
        
        progressView.progressTintColor = UIColor(red: CGFloat(110.0/255.0), green: CGFloat(165.0/255.0), blue: CGFloat(20.0/255.0), alpha: CGFloat(1.0))
        progressView.trackTintColor = UIColor(red: CGFloat(51.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(51.0/255.0), alpha: CGFloat(1.0))
        progressView.progress = 0.5
    }
    
    func createToolbar(){
        
        toolBar.backgroundColor = UIColor(red: CGFloat(110.0/255.0), green: CGFloat(165.0/255.0), blue: CGFloat(20.0/255.0), alpha: CGFloat(1.0))
        
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        
        
        
        let button:UIButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.setImage(UIImage(named: "icon-close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        button.addTarget(self, action: #selector(buttonClose), for: .touchUpInside)
        
        
        
        toolBar.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        
        
        
        let labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        labelTitle.textAlignment = .center
        labelTitle.text = pageTitle
        labelTitle.textColor = UIColor.white
        toolBar.addSubview(labelTitle)
        
        
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.leadingAnchor.constraint(equalTo: toolBar.leadingAnchor).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: toolBar.trailingAnchor).isActive = true
        labelTitle.topAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
        labelTitle.bottomAnchor.constraint(equalTo: toolBar.bottomAnchor).isActive = true
        
        labelTitle.center = toolBar.center
        
        
        toolBar.isUserInteractionEnabled = true
        
        self.view.addSubview(toolBar)
        
        //if #available(iOS 11.0, *) {
        //let safeGuide = self.view.safeAreaLayoutGuide
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        toolBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        toolBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //} else {
        // Fallback on earlier versions
        //}
        
        
        
        
        
        
        
    }
    
    @objc func cancelClick() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func buttonClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refreshButtonsState()
    }
    
    func refreshButtonsState() {
        updateNavigationButton(buttonForward, webView?.canGoForward ?? false)
        updateNavigationButton(buttonBack, webView?.canGoBack ?? false)
    }
    
    func updateNavigationButton(_ button: UIButton,_ isActive: Bool){
        if (isActive == false){
            button.layer.borderColor = colorButtonsDisable.cgColor
            button.tintColor = colorButtonsDisable
        }else{
            button.layer.borderColor = colorButtonsEnable.cgColor
            button.tintColor = colorButtonsEnable
        }
        
        button.isEnabled = isActive
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(self.webView!.estimatedProgress);
        }
    }
    
    func createButton(_ button: UIButton){
        button.backgroundColor = .clear
        button.layer.cornerRadius = 1
        button.layer.borderWidth = 1
        button.layer.borderColor = colorButtonsEnable.cgColor
    }
    
    
}
