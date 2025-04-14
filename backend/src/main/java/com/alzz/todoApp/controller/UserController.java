package com.alzz.todoApp.controller;

import org.springframework.web.bind.annotation.*;
import com.alzz.todoApp.model.User;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    List<User> users = new ArrayList<>();

    @PostMapping
    public User addUser(@RequestBody User user) {
        users.add(user);
        return user;
    }

    @GetMapping
    public List<User> getAllUsers() {
        return users;
    }
}
