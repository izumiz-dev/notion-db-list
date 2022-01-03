//
//  ContentView.swift
//  notion-db-list
//
//  Created by Izumi Zama on 2022/01/03.
//

import SwiftUI

struct ContentView: View {
    init() {
        // SchemeからNotion API Tokenを取得
        let NOTION_API_TOKEN = ProcessInfo.processInfo.environment["NOTION_API_TOKEN"]!
        // SchemeからDatabase IDを取得
        let NOTION_DATABASE_ID = ProcessInfo.processInfo.environment["NOTION_DATABASE_ID"]!
        // Endpoint URL
        let url = URL(string: "https://api.notion.com/v1/databases/\(NOTION_DATABASE_ID)/query")!
        // Notionのデータベースをフィルタ
        // https://developers.notion.com/reference/post-database-query
        let queryFilter: [String: Any] =
        ["filter": [
            "property": "Status",
            "select": [
                "does_not_equal": "DONE"
            ]
        ]]
        // JSONに変換
        let jsonBody = try? JSONSerialization.data(withJSONObject: queryFilter)
        
        // URLリクエストインスタンスの作成
        var request = URLRequest(url: url)
        // メソッドをPOSTに
        request.httpMethod = "POST"
        // HTTPリクエストのヘッダの設定
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2021-08-16", forHTTPHeaderField: "Notion-Version")
        request.addValue(NOTION_API_TOKEN, forHTTPHeaderField: "authorization")
        
        // HTTPリクエストのBODYに先ほどのフィルタを入れる
        request.httpBody = jsonBody
        
        // ここで実際にリクエストを投げる．
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let response = try JSONSerialization.jsonObject(with:data, options: [])
                print(response)
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    var body: some View {
        Text("Notion Database List App \nUnder Construction")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
