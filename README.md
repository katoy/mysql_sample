# psql_sample

```text
fluttter 3.6 で mysql を使った TODO アプリを示してください。
コードブロックだけを示してください。
ファイル構成は次のようにしてください。
todo_app/
  |- android/
  |- ios/
  |- lib/
      |- models/
          |- task_model.dart
      |- provider/
          |- task_provider.dart
      |- screens/
          |- home_screen.dart
          |- task_form_screen.dart
      |- main.dart
  |- pubspec.yaml

ファイル単位で回答は分割してください。”次を示してください" と質問したら、順番に回答をしてしてください。
```

```shell
mkdir models
mkdir provider
mkdir screens
touch models/task_model.dart
touch provider/task_provider.dart
touch screens/home_screen.dart
touch screens/task_form_screen.dart
```

```text
この todo アプリ用の DB を作成する手順を教えてください。mysql のインストールと mysql コマンド "mysql -u root -p" での起動ができる設定はすんでいます。

既に MySQL がインストールされているとのことで、以下の手順でデータベースとテーブルを作成してください。

ターミナルまたはコマンドプロンプトで mysql -u root -p を実行し、パスワードを入力して MySQL にログインします。

新しいデータベースを作成します。以下のコマンドを実行してデータベースを作成してください（データベース名はお好みで変更できます）。

sql
Copy code
CREATE DATABASE todo_app_db;
新しく作成したデータベースを使用するように指定します。

Copy code
USE todo_app_db;
tasks テーブルを作成します。以下のコマンドを実行してテーブルを作成してください。

sql
Copy code
CREATE TABLE tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  isCompleted BOOLEAN DEFAULT 0
);
これで、データベースとテーブルの作成が完了しました。次に、task_provider.dart ファイルの ConnectionSettings を更新し、先ほど作成したデータベースに接続します。

dart
Copy code
ConnectionSettings(
  host: 'YOUR_HOST_HERE', // ホスト名を入力（ローカルホストの場合は 'localhost'）
  port: 3306, // MySQL のポート番号（デフォルトは 3306）
  user: 'YOUR_USER_HERE', // ユーザ名を入力（例: 'root'）
  password: 'YOUR_PASSWORD_HERE', // パスワードを入力
  db: 'todo_app_db', // 先ほど作成したデータベース名
)
これで、データベースの作成と接続設定が完了しました。アプリケーションを実行してデータベースを利用できることを確認してください。
```
```text
この todo アプリのための rest api を python で作ってください。
```

```text
mysql.server start

cd app
flask run --host=0.0.0.0 --port=5001
```
