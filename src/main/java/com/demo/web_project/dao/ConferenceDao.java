package com.demo.web_project.dao;

import com.demo.web_project.vo.Conference;
import java.util.List;

public interface ConferenceDao {
    Conference findByCodes(String invite_codes);
    List<Conference> findAll(String keyword);
    List<Conference> findByOrganizerId(int organizerId);
}
