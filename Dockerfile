# ビルドステージ
FROM eclipse-temurin:17-jdk AS builder

# 必要なツールをインストール
RUN apt-get update && apt-get install -y zip

WORKDIR /app

# ソースとライブラリをコピー
COPY src/ src/

# クラスのコンパイル
RUN mkdir -p target/WEB-INF/classes
RUN find src/main/java -name "*.java" -print | xargs javac -d target/WEB-INF/classes -cp "src/main/webapp/WEB-INF/lib/*:/usr/local/tomcat/lib/*"

# Webリソースをコピー
RUN cp -r src/main/webapp/* target/
RUN cp -r src/main/webapp/WEB-INF/lib target/WEB-INF/

# WARファイルを作成
RUN cd target && jar -cvf ../myapp.war *

# 実行ステージ
FROM tomcat:10-jdk17

# Tomcatのデフォルトアプリを削除
RUN rm -rf /usr/local/tomcat/webapps/*

# WARファイルをコピー
COPY --from=builder /app/myapp.war /usr/local/tomcat/webapps/ROOT.war

# ポート設定
EXPOSE 8080

# Tomcatを起動
CMD ["catalina.sh", "run"]