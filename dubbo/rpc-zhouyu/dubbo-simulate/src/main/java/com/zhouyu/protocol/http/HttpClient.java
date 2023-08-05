package com.zhouyu.protocol.http;

import com.alibaba.fastjson.JSONObject;
import com.zhouyu.framework.Invocation;
import org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.net.*;

public class HttpClient {

    public String send(String hostname, Integer port, Invocation invocation) {

        // 读取用户的配置

        try {
            URL url = new URL("http", hostname, port, "/");
            HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();

            httpURLConnection.setRequestMethod("POST");
            httpURLConnection.setDoOutput(true);

            OutputStream outputStream = httpURLConnection.getOutputStream();
            ObjectOutputStream oos = new ObjectOutputStream(outputStream);

            oos.writeObject(invocation); // 写入发送的内容
            oos.flush(); // 发送
            oos.close();

            InputStream inputStream = httpURLConnection.getInputStream(); // 等待返回的结果
            String result = IOUtils.toString(inputStream);
            return result;
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;

    }
}
