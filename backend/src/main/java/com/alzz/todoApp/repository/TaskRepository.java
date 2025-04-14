package com.alzz.todoApp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.alzz.todoApp.model.Task;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
}
