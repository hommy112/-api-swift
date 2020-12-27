//
//  ViewController.swift
//  zhihu_like
//
//  Created by hanyang on 2020/12/26.
//

import UIKit
import Moya


enum MyService {
    case admin
}

class Author {
    var avatar_url: String?
    var avatar_url_template: String?
    var description: String?
    var gender: Int?
    var headline: String?
    var id: String?
    var is_advertiser: Bool?
    var is_followed: Bool?
    var is_org: Bool?
    var name: String?
    var type: String?
    var uid: String?
    var url: String?
    var url_token: String?
    var user_type: String?
}


class AutorInfo {
    var accept_submission: Int?
    var articles_count: Int?
    var can_manage: Bool?
    var column_type: String?
    var author: Author?
    var comment_permission: String?
    var created: String?
    var description: String?
    var followers: Int?
    var id: String?
    var image_url: String?
    var intro: String?
    var is_following: Bool?
    var items_count: Int?
    var title: String?
}





extension MyService: TargetType {
    var sampleData: Data {
        return "".utf8Encoded
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var baseURL: URL { return URL(string: "https://zhuanlan.zhihu.com/api/columns")! }
    var path: String {
        switch self {
        case .admin:
            return "/zhihuadmin"
            
        }
    }
    var method: Moya.Method {
        
        switch self {
        case .admin:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .admin:
            return .requestPlain
            
        }
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}


class Plugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print("prepare")
        var mRequest = request
        mRequest.timeoutInterval = 20
        return mRequest
    }
    func willSend(_ request: RequestType, target: TargetType) {
        print("开始请求")
        
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("结束请求")
        if case let .success(response) = result {
            let jsonString = try? response.mapString()
            print(jsonString)
        }
        
    }
    //            let errorReason: String = (result.error?.errorDescription)!
    //            print("请求失败：\(errorReason)")
    //            var tip = ""
    //            if errorReason.contains("The Internet connection appears to be offline") {
    //                tip = "网络不给力，请检查您的网络"
    //            }else if errorReason.contains("Could not connect to the server") {
    //                tip = "无法连接服务器"
    //            }else {
    //               tip = "请求失败"
    //            }
    /// 使用tip文字 进行提示
}




class ViewController: UIViewController {
    var tabbarVC: UITabBarController = UITabBarController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTabarController()
        requestData()
        
    }
    
    
    private func setUpTabarController() -> Void {
        
    }
    
    private func requestData() -> Void {
        let provider = MoyaProvider<MyService>()
        
        
        provider.request(.admin) { result in
            // do something with the result (read on for more details)
            
            
            switch result {
            case let .success(moyaResponse):
                do {
                    let data = moyaResponse.data
                    let statusCode = moyaResponse.statusCode
                    //                    let response = try result.get()
                    //                    let value = try response.mapNSArray()
                    //                    self.repos = value
                    //                    self.tableView.reloadData()
                    let value = try result.get()
                    let value1 = try value.mapJSON()
                    print(value1)
                    
                } catch {
                    let printableError = error as CustomStringConvertible
                }
                
            // do something in your app
            case let .failure(error):
                print(error.errorCode)
                
            // TODO: handle the error == best. comment. ever.
            }
            
            
            
        }
        
        
    }
}
