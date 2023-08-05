package com.zhouyu.protocol.http;

import com.zhouyu.framework.Invocation;
import org.apache.commons.io.IOUtils;
import com.zhouyu.register.LocalRegister;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class HttpServerHandler {

    public void handler(HttpServletRequest req, HttpServletResponse resp) {

        try {
            Invocation invocation = (Invocation) new ObjectInputStream(req.getInputStream()).readObject();
            String interfaceName = invocation.getInterfaceName();
            Class implClass = LocalRegister.get(interfaceName); // 根据接口的名字拿到实现类（之前在provider中注册的信息）
            Method method = implClass.getMethod(invocation.getMethodName(), invocation.getParamType());
            // 在这里真正实现了：根据一个请求，调用了对应的服务
            String result = (String) method.invoke(implClass.newInstance(), invocation.getParams()); // 当前请求所要调用的服务执行完后的结果

            System.out.println("tomcat:" + result);
            IOUtils.write(result, resp.getOutputStream()); // 方便的将 result 这个字符串写到 outputStream 中，实现结果返回
        } catch (IOException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }


    }
}
