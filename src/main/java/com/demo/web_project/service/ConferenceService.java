package com.demo.web_project.service;
import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.impl.ConferenceDaoImpl;
import com.demo.web_project.vo.Conference;

import java.util.List;
import java.util.Random;

public class ConferenceService {
    private ConferenceDao conferenceDao= new ConferenceDaoImpl();
    public Conference findByCodes(String invite_codes){
        return conferenceDao.findByCodes(invite_codes);
    }
    public List<Conference> findAll(String keyword){
        return conferenceDao.findAll(keyword);
    }
    public List<Conference> getMyList(int organizerId){
        return conferenceDao.findByOrganizerId(organizerId);
    }
    public  List<Conference> findDefault(){
        return conferenceDao.findDefault();
    }
    public Conference findByConfID(int confID ){
        return  conferenceDao.findByConfID(confID);
    }

    public List<Conference> findByOrganizerId(int organizerId) {
        return conferenceDao.findByOrganizerId(organizerId);
    }

    public int createConference(Conference conference) {
        return conferenceDao.create(conference);
    }

    public boolean updateConference(Conference conference, int organizerId) {
        Conference existing = conferenceDao.findById(conference.getId());
        if (existing == null || existing.getOrganizer_id() != organizerId || !"pending".equals(existing.getStatus())) {
            return false;
        }
        return conferenceDao.update(conference) > 0;
    }

    public boolean deleteConference(int conferenceId, int organizerId) {
        Conference existing = conferenceDao.findById(conferenceId);
        if (existing == null || existing.getOrganizer_id() != organizerId) {
            return false;
        }
        return conferenceDao.delete(conferenceId) > 0;
    }

    public Conference getConferenceById(int conferenceId) {
        return conferenceDao.findById(conferenceId);
    }

    public String generateInviteCode(int conferenceId, int organizerId) {
        Conference existing = conferenceDao.findById(conferenceId);
        if (existing == null || existing.getOrganizer_id() != organizerId || !"approved".equals(existing.getStatus())) {
            return null;
        }

        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder(9);
        Random random = new Random();
        for (int i = 0; i < 9; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        String inviteCode = sb.toString();

        int result = conferenceDao.updateInviteCode(conferenceId, inviteCode);
        return result > 0 ? inviteCode : null;
    }

    public List<Conference> findByStatus(String status) {
        return conferenceDao.findByStatus(status);
    }

    public List<Conference> findPendingConferences() {
        return conferenceDao.findPendingConferences();
    }

    public List<Conference> findAllConferences() {
        return conferenceDao.findAllConferences();
    }

    public boolean approveConference(int conferenceId, String reason) {
        Conference existing = conferenceDao.findById(conferenceId);
        if (existing == null || !"pending".equals(existing.getStatus())) {
            return false;
        }
        return conferenceDao.approveConference(conferenceId, reason) > 0;
    }

    public boolean rejectConference(int conferenceId, String reason) {
        Conference existing = conferenceDao.findById(conferenceId);
        if (existing == null || !"pending".equals(existing.getStatus())) {
            return false;
        }
        return conferenceDao.rejectConference(conferenceId, reason) > 0;
    }
}