FROM tomcat:10-jdk17

# Tomcatのデフォルトアプリを削除
RUN rm -rf /usr/local/tomcat/webapps/*

# WARファイルをコピー (リポジトリのルートに置いたWARファイル名を指定)
COPY book.war /usr/local/tomcat/webapps/ROOT.war

# ポート設定
ENV PORT 8080
EXPOSE 8080

# Tomcatを起動
CMD ["catalina.sh", "run"]
