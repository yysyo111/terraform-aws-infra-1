# 1. 公式の Nginx イメージを元にする
FROM nginx:latest

# 2. 自分の Web サイト用の HTML ファイルをコピーする
COPY ./html /usr/share/nginx/index.html

# 3. コンテナが起動したら Nginx を実行する
CMD ["nginx", "-g", "daemon off;"]