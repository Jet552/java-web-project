package com.demo.web_project.service;
import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.impl.ConferenceDaoImpl;
import com.demo.web_project.vo.Conference;

import java.util.List;

public class ConferenceService {
    private ConferenceDao conferenceDao= new ConferenceDaoImpl();
    public Conference findByCodes(String invite_codes){
        return conferenceDao.findByCodes(invite_codes);
    }
    public List<Conference> findAll(String keyword){
        return conferenceDao.findAll(keyword);
    }
}
