package com.beyproject.springJwt.service;

import com.beyproject.springJwt.response.UserResponse;
import com.beyproject.springJwt.model.User;
import com.beyproject.springJwt.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void UpdateUser(User user)
    {
        var foundUser = userRepository.findByUsername(user.getUsername());
        User u = foundUser.get();

        u.setFirstName(user.getFirstName());
        u.setLastName(user.getLastName());

        userRepository.save(u);

    }

    public UserResponse findByUsername(String username) {
        var foundUser = userRepository.findByUsername(username);
        User user = foundUser.get();

        return new UserResponse(user.getUsername(),user.getPassword(),user.getFirstName(),user.getLastName());

    }

}
