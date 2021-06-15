#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <string.h>

int main(void) {

    int rsock, wsock;
    struct sockaddr_in addr, client;
    int len;
    int ret;

    char buf[2048];
    char inbuf[2048];

    /* make socket */
    rsock = socket(AF_INET, SOCK_STREAM, 0);

    if (rsock < 0) {
        fprintf(stderr, "Error. Cannot make socket\n");
        return -1;
    }

    /* socket setting */
    addr.sin_family      = AF_INET;
    addr.sin_port        = htons(8080);
    addr.sin_addr.s_addr = INADDR_ANY;

    /* binding socket */
    ret = bind(rsock, (struct sockaddr *)&addr, sizeof(addr));

    if (ret < 0) {
        fprintf(stderr, "Error. Cannot bind socket\n");
        return -1;
    }

    /* listen socket */
    listen(rsock, 5);

    /* write buf */
    memset(buf, 0, sizeof(buf));
    snprintf(buf, sizeof(buf),
                "HTTP/1.1 200 OK\r\n"
                        "Date: Mon, 14 Jul 2021 23:50:20 GMT\r\n"
                        "Server: DEMO Web Server\r\n"
                        "Last-Modified: Mon, 26 Feb 2021 23:50:20 GMT\r\n"
                        "Accept-Ranges: bytes\r\n"
                        "Content-Length: 6\r\n"
                        "Connection: close\r\n"
                        "Content-Type: text/html; charset=UTF-8\r\n"
                        "\r\n"
                        "HELLO\r\n");

    while (1) {
        /* accept TCP connection from client */
        /* 引数がポインタだからわざわざ変数を定義している */
        len = sizeof(client);
        wsock = accept(rsock, (struct sockaddr *)&client, &len);

        /* send message */
        memset(inbuf, 0, sizeof(inbuf));
        recv(wsock, inbuf, sizeof(inbuf), 0);
        send(wsock, buf, (int) strlen(buf), 0);

        close(wsock);
    }

    /* close TCP session */
    close(rsock);

    return 0;
}
