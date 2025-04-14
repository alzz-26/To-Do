package com.alzz.todoApp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.alzz.todoApp.model.Task;
import com.alzz.todoApp.repository.TaskRepository;

import java.util.List;

@RestController
@RequestMapping("/tasks")
public class TaskController {

    @Autowired
    private TaskRepository taskRepo;

    @GetMapping
    public List<Task> getAllTasks() {
        return taskRepo.findAll();
    }

    @PostMapping
    public Task addTask(@RequestBody Task task) {
        return taskRepo.save(task);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Task> updateTask(@PathVariable Long id) {
        for (Task task : taskRepo.findAll()) {
            if (task.getId().equals(id)) {
                task.setCompleted(!task.isCompleted());
                return ResponseEntity.ok(task);
            }
        }
        return ResponseEntity.notFound().build();
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteTask(@PathVariable Long id) {
        if (taskRepo.existsById(id)) {
            taskRepo.deleteById(id);
            return ResponseEntity.ok("Task deleted");
        } else {
            return ResponseEntity.notFound().build();
        }
    }
}
