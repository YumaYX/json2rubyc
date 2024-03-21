# json2rubyc

RubyでパースしたJSONのデータ構造を簡素化して表示する。モチベーションは、複雑なJSONファイルの構造を理解し、その上で、簡単にRubyで利用可能にすることである。

- Hash：インデントを使って、親子関係を表示する。Hashに変換されているため、["key"]などを接続して、値を取り出せる
- Array：each文で、Arrayを扱えるように、Rubyのスクリプトコードを出力する。JSONのデータを示していない、処理内容を記載していないなど、式が完全でないため、使用するためには修正が必要である。

参考：出力に表示されるキーについて、表示されるキーは、データ要素に含まれるキーの和集合である。そのため、要素によっては、存在しないキーが含まれることがある。正規化、クレンジングはご自由に。

## 使い方

```sh
ruby json2rubyc.rb sample.json
```

## 入力用JSONファイル

```json
{
  "user": {
    "id": 123,
    "name": "Alice",
    "email": "alice@example.com",
    "address": {
      "street": "123 Main St",
      "city": "City",
      "country": "Country"
    }
  },
  "items": [
    {
      "id": 1,
      "name": "Item 1",
      "quantity": 2,
      "price": 10.99
    },
    {
      "id": 2,
      "name": "Item 2",
      "quantity": 1,
      "price": 5.99
    }
  ],
  "total": 27.97
}
```

## 出力

```ruby
# Original Data Length: 3
["user"]
  ["id"] # (Integer)
  ["name"] # (String)
  ["email"] # (String)
  ["address"]
    ["street"] # (String)
    ["city"] # (String)
    ["country"] # (String)
["items"].each do |element|
  puts element
    ["id"] # (Integer)
    ["name"] # (String)
    ["quantity"] # (Integer)
    ["price"] # (Float)
end
["total"] # (Float)
```

`json_parsed`をパースしたJSONデータとした場合、`json_parsed["user"]["id"]`や、`json_parsed["user"]["address"]["city"]`、`json_parsed["total"]`などが使用できることがわかる。

また、`["items"]`については、`json_parsed`をつけて、コピペで、ループ文を回せる。キーのインデントが一段下がっているのは、Arrayの下に、Hashが隠れているため。`element["quantity"]`等で使用可能である。
