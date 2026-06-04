package com.demo.web_project.dao;

import com.demo.web_project.vo.Attendee;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.vo.Payment;
import java.util.List;

public interface ConferenceDao {
    Conference findByCodes(String invite_codes);
    List<Conference> findAll(String keyword);
    public List<Conference> findDefault();
    public Conference findByConfID(int confID );
    List<Conference> findByOrganizerId(int organizerId);
    int create(Conference conference);
    int update(Conference conference);
    int delete(int id);
    Conference findById(int id);
    int updateInviteCode(int conferenceId, String inviteCode);
    
    List<Conference> findByStatus(String status);
    List<Attendee> findAllAttendees();
    List<Payment> findAllPayments();
    List<Payment> findPaymentsByStatus(String status);
    
    List<Conference> findPendingConferences();
    List<Conference> findAllConferences();
    int approveConference(int id, String reason);
    int rejectConference(int id, String reason);
}
