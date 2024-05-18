package com.beyproject.springJwt.controller;

import com.beyproject.springJwt.response.UserResponse;
import com.beyproject.springJwt.service.UserService;
import com.beyproject.springJwt.model.User;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class DemoController {
    private UserService userService;

    public DemoController(UserService userService) {
        this.userService = userService;
    }


    @PostMapping("/update")
    public ResponseEntity<String> update(@RequestBody User userToUpdate) {

        userService.UpdateUser(userToUpdate);
        return ResponseEntity.ok("User Udpate");
    }

    @PostMapping("/getuser")
    public ResponseEntity<UserResponse> getuser(@RequestBody User username) {

        var user = userService.findByUsername(username.getUsername());

        return ResponseEntity.ok(user);

    }

    @GetMapping("/admin_only")
    public ResponseEntity<String> adminOnly() {
        return ResponseEntity.ok("Only Admin");
    }
}
