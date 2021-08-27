---
layout: post
status: publish
published: true
title: Netty WebSocket 示例


date: '2016-01-03 21:12:37 +0800'
date_gmt: '2016-01-03 13:12:37 +0800'
categories:
- Opensource
tags:
- netty
- WebSocket
comments: []
---
<p>代码:</p>
<p>Server</p>
<div class="cnblogs_code">
<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a title="复制代码"><img src="http://common.cnblogs.com/images/copycode.gif" alt="复制代码" /></a></span></div>
<pre>package netty.protocol.websocket.server;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.Channel;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.http.HttpObjectAggregator;
import io.netty.handler.codec.http.HttpServerCodec;
import io.netty.handler.stream.ChunkedWriteHandler;

/**
 * TODO
 *
 * @description
 * @author ez
 * @time 2015年6月3日 下午4:42:31
 */
public class WebSocketServer {
    public void run(int port) throws Exception {
        EventLoopGroup bossGroup = new NioEventLoopGroup();
        EventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            ServerBootstrap b = new ServerBootstrap();
            b.group(bossGroup, workerGroup)
                    .channel(NioServerSocketChannel.class)
                    .childHandler(new ChannelInitializer<SocketChannel>() {

                        @Override
                        protected void initChannel(SocketChannel ch)
                                throws Exception {
                            ChannelPipeline pipeline = ch.pipeline();
                            /*
                             * HttpServerCodec ,将请求和应答消息编码或者解码为HTTP消息
                             */
                            pipeline.addLast("http-codec",
                                    new HttpServerCodec());
                            /*
                             * HttpObjectAggregator ,
                             * 将HTTP消息的多个部分组合成一条完整的HTTP消息;
                             */
                            pipeline.addLast("aggregator",
                                    new HttpObjectAggregator(65536));
                            /*
                             * ChunkedWriteHandler ,
                             * 的主要作用是支持异步发送大的码流(例如大文件传输),但不占用过多的内存,防止JAVA内存溢出
                             */
                            ch.pipeline().addLast("http-chunked",
                                    new ChunkedWriteHandler());
                            /*
                             * WebSocketServerHandler 自己的业务处理
                             */
                            pipeline.addLast("handler",
                                    new WebSocketServerHandler());
                        }
                    });

            Channel ch = b.bind(port).sync().channel();
            System.out.println("Web socket server started at port " + port
                    + '.');
            System.out
                    .println("Open your browser and navigate to http://localhost:"
                            + port + '/');

            ch.closeFuture().sync();
        } finally {
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }

    public static void main(String[] args) throws Exception {
        int port = 8080;
        if (args.length > 0) {
            try {
                port = Integer.parseInt(args[0]);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        new WebSocketServer().run(port);
    }
}</pre>
<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a title="复制代码"><img src="http://common.cnblogs.com/images/copycode.gif" alt="复制代码" /></a></span></div>
</div>
<p>&nbsp;</p>
<p>Handler</p>
<div class="cnblogs_code">
<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a title="复制代码"><img src="http://common.cnblogs.com/images/copycode.gif" alt="复制代码" /></a></span></div>
<pre>package netty.protocol.websocket.server;

import static io.netty.handler.codec.http.HttpHeaders.isKeepAlive;
import static io.netty.handler.codec.http.HttpHeaders.setContentLength;
import static io.netty.handler.codec.http.HttpResponseStatus.BAD_REQUEST;
import static io.netty.handler.codec.http.HttpVersion.HTTP_1_1;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelFutureListener;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.codec.http.DefaultFullHttpResponse;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.handler.codec.http.websocketx.CloseWebSocketFrame;
import io.netty.handler.codec.http.websocketx.PingWebSocketFrame;
import io.netty.handler.codec.http.websocketx.PongWebSocketFrame;
import io.netty.handler.codec.http.websocketx.TextWebSocketFrame;
import io.netty.handler.codec.http.websocketx.WebSocketFrame;
import io.netty.handler.codec.http.websocketx.WebSocketServerHandshaker;
import io.netty.handler.codec.http.websocketx.WebSocketServerHandshakerFactory;
import io.netty.util.CharsetUtil;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * TODO
 *
 * @description
 * @author ez
 * @time 2015年6月3日 下午4:42:59
 */
public class WebSocketServerHandler extends SimpleChannelInboundHandler<Object> {
    private static final Logger logger = Logger
            .getLogger(WebSocketServerHandler.class.getName());

    private WebSocketServerHandshaker handshaker;

    @Override
    public void messageReceived(ChannelHandlerContext ctx, Object msg)
            throws Exception {
        // 传统的HTTP接入
        if (msg instanceof FullHttpRequest) {
            handleHttpRequest(ctx, (FullHttpRequest) msg);
        }
        // WebSocket接入
        else if (msg instanceof WebSocketFrame) {
            handleWebSocketFrame(ctx, (WebSocketFrame) msg);
        }
    }

    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
        ctx.flush();
    }

    private void handleHttpRequest(ChannelHandlerContext ctx,
            FullHttpRequest req) throws Exception {

        // 如果HTTP解码失败，返回HHTP异常
        if (!req.getDecoderResult().isSuccess()
                || (!"websocket".equals(req.headers().get("Upgrade")))) {
            sendHttpResponse(ctx, req, new DefaultFullHttpResponse(HTTP_1_1,
                    BAD_REQUEST));
            return;
        }

        // 构造握手响应返回，本机测试
        WebSocketServerHandshakerFactory wsFactory = new WebSocketServerHandshakerFactory(
                "ws://localhost:8080/websocket", null, false);
        handshaker = wsFactory.newHandshaker(req);
        if (handshaker == null) {
            WebSocketServerHandshakerFactory
                    .sendUnsupportedWebSocketVersionResponse(ctx.channel());
        } else {
            handshaker.handshake(ctx.channel(), req);
        }
    }

    private void handleWebSocketFrame(ChannelHandlerContext ctx,
            WebSocketFrame frame) {

        // 判断是否是关闭链路的指令
        if (frame instanceof CloseWebSocketFrame) {
            handshaker.close(ctx.channel(),
                    (CloseWebSocketFrame) frame.retain());
            return;
        }
        // 判断是否是Ping消息
        if (frame instanceof PingWebSocketFrame) {
            ctx.channel().write(
                    new PongWebSocketFrame(frame.content().retain()));
            return;
        }
        // 本例程仅支持文本消息，不支持二进制消息
        if (!(frame instanceof TextWebSocketFrame)) {
            throw new UnsupportedOperationException(String.format(
                    "%s frame types not supported", frame.getClass().getName()));
        }

        // 返回应答消息
        String request = ((TextWebSocketFrame) frame).text();
        if (logger.isLoggable(Level.FINE)) {
            logger.fine(String.format("%s received %s", ctx.channel(), request));
        }
        ctx.channel().writeAndFlush(
                new TextWebSocketFrame(request
                        + " , 欢迎使用Netty WebSocket服务，现在时刻："
                        + new java.util.Date().toString()));
        for (int i = 0; i < 100; i++) {
            ctx.channel().writeAndFlush(
                    new TextWebSocketFrame(request + i
                            + new java.util.Date().toString()));
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    private static void sendHttpResponse(ChannelHandlerContext ctx,
            FullHttpRequest req, FullHttpResponse res) {
        // 返回应答给客户端
        if (res.getStatus().code() != 200) {
            ByteBuf buf = Unpooled.copiedBuffer(res.getStatus().toString(),
                    CharsetUtil.UTF_8);
            res.content().writeBytes(buf);
            buf.release();
            setContentLength(res, res.content().readableBytes());
        }

        // 如果是非Keep-Alive，关闭连接
        ChannelFuture f = ctx.channel().writeAndFlush(res);
        if (!isKeepAlive(req) || res.getStatus().code() != 200) {
            f.addListener(ChannelFutureListener.CLOSE);
        }
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause)
            throws Exception {
        cause.printStackTrace();
        ctx.close();
    }
}</pre>
<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a title="复制代码"><img src="http://common.cnblogs.com/images/copycode.gif" alt="复制代码" /></a></span></div>
</div>
<p>html</p>
<div class="cnblogs_code">
<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy"><a title="复制代码"><img src="http://common.cnblogs.com/images/copycode.gif" alt="复制代码" /></a></span></div>
<pre><!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
Netty WebSocket 时间服务器
</head>
<br>
<body>
<br>
<script type="text/javascript">
var socket;
if (!window.WebSocket) 
{
    window.WebSocket = window.MozWebSocket;
}
if (window.WebSocket) {
    socket = new WebSocket("ws://localhost:8080/websocket");
    socket.onmessage = function(event) {
        var ta = document.getElementById('responseText');
         
        ta.value += event.data
    };
    socket.onopen = function(event) {
        var ta = document.getElementById('responseText');
        ta.value = "打开WebSocket服务正常，浏览器支持WebSocket!";
    };
    socket.onclose = function(event) {
        var ta = document.getElementById('responseText');
        ta.value = "";
        ta.value = "WebSocket 关闭!"; 
    };
}
else
    {
    alert("抱歉，您的浏览器不支持WebSocket协议!");
    }

function send(message) {
    if (!window.WebSocket) { return; }
    if (socket.readyState == WebSocket.OPEN) {
        socket.send(message);
    }
    else
        {
          alert("WebSocket连接没有建立成功!");
        }
}
</script>
<form onsubmit="return false;">
<input type="text" name="message" value="Netty最佳实践"/>
<br><br>
<input type="button" value="发送WebSocket请求消息" onclick="send(this.form.message.value)"/>
<hr color="blue"/>
<h3>服务端返回的应答消息</h3>
<textarea id="responseText" style="width:500px;height:300px;"></textarea>
</form>
</body>
</html></pre>
</div>
<div class="cnblogs_code_toolbar"><span class="cnblogs_code_copy">摘自『http://www.cnblogs.com/mjorcen/p/4549784.html』</span></div>
