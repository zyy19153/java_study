package com.zhouyu.provider;

import com.zhouyu.api.ProviderServiceInterface;
import com.zhouyu.api.User;
import org.apache.dubbo.config.annotation.Service;

@Service
public class ProviderService implements ProviderServiceInterface {

    public User getUser() {
        return new User("周瑜");
    }
}
