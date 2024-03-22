# json2rubyc

RubyでパースしたJSONのデータ構造を簡素化して表示する。モチベーションは、複雑なJSONファイルの構造を理解し、その上で、簡単にRubyで利用可能にすることである。

- Hash：インデントを使って、親子関係を表示する。Hashに変換されているため、["key"]などを接続して、値を取り出せる
- Array：each文で、Arrayを扱えるように、Rubyのスクリプトコードを出力する。JSONのデータを示していない、処理内容を記載していないなど、式が完全でないため、使用するためには修正が必要である。Arrayの要素はキーを持たないため、キーとして、出力されないため注意。

参考：出力に表示されるキーについて、表示されるキーは、データ要素に含まれるキーの和集合である。そのため、要素によっては、存在しないキーが含まれることがある。正規化、クレンジングはご自由に。

## 使い方

```sh
ruby app.rb input.json
```

## Sample

```json
{
  "key1":"v1",
  "key2":{
      "key2-1":"v2-1",
      "key2-2":"v2-2"
  },
  "key3":[
    0,
    true,
    {
      "key3-1":"v3-1",
      "key3-2":"v3-2"
    },
    {
      "key4-1":"v4-1",
      "key4-2":"v4-2"
    }
  ]
}
```

```ruby
# Original Data Length: 3
# Original Data Class: Hash
["key1"] # (String)
["key2"].each do |key, value|
  ["key2-1"] # (String)
  ["key2-2"] # (String)
end
["key3"].each do |element|
  puts element
    ["key3-1"] # (String)
    ["key3-2"] # (String)
    ["key4-1"] # (String)
    ["key4-2"] # (String)
end
```

```json
[
  {
    "key1":1,
    "key2":2,
    "key3":3
  },
  {
    "key1":1,
    "key2":2,
    "key3":3,
    "key4":4
  },
  {
    "key1":1,
    "key2":2,
    "key3":3
  }
]
```

```ruby
# Original Data Length: 3
# Original Data Class: Array
json_parsed.each do |element|
  puts element
    ["key4"] # (Integer)
    ["key1"] # (Integer)
    ["key2"] # (Integer)
    ["key3"] # (Integer)
end
```
