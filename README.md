# NOTE×NOTE

Webアプリの構成要素を学ぶためのメモアプリです。

## スクリーンショット

TODO

## 開発環境

|項目|バージョン|
|:---|---------:|
|Ruby|3.1.1|
|Sinatra|2.2.0|
|Puma|5.6.4|

## インストール

1. 本リポジトリを `git clone` してください
```
  $ git clone https://github.com/maeda-m/sinatra-note-app.git --branch develop
```
2. 次のコマンドで依存ライブラリをインストールしてください
```
  $ cd sinatra-note-app
  $ bundle install
```

## 実行方法

1. 次のコマンドでWebサーバーを起動してください
```
  $ cd sinatra-note-app
  $ bundle exec puma
```
2. ブラウザで http://localhost:9292/ にアクセスしてください
3. 終了する場合は `Ctrl + C` でWebサーバーを停止してください

## テスト方法

```
$ cd sinatra-note-app
$ rake test
```

## Linter

```
$ cd sinatra-note-app
$ rubocop
```
