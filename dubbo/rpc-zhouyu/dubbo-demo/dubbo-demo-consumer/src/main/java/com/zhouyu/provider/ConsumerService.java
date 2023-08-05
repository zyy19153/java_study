package com.zhouyu.provider;

import com.alibaba.fastjson.JSONObject;
import com.zhouyu.api.ProviderServiceInterface;
import com.zhouyu.api.User;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.stereotype.Service;

@Service
public class ConsumerService {

    @Reference
    private ProviderServiceInterface providerService;

    public String test() {
//        String result = HttpClient.get("http://localhost:8080/provider/service");
//        User user = JSONObject.parseObject(result, User.class);
//        return user.getUsername();

        User user = providerService.getUser();
        return user.getUsername();
    }
}
