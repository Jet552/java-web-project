import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.impl.ConferenceDaoImpl;
import com.demo.web_project.vo.Conference;
import org.junit.jupiter.api.Test;

import java.util.List;

public class FindConferenceTest {
    private ConferenceDao conferenceDao= new ConferenceDaoImpl();
    @Test
    public void testcode(){
        String code="7aB9cD2eF";
        Conference conference=conferenceDao.findByCodes(code);
        System.out.println(conference.getTitle());
    }
    @Test
    public  void testkeyword(){
        String keyword="会" ;
        List<Conference> conferenceList=conferenceDao.findAll(keyword);
        for (int i = 0; i < conferenceList.size(); i++) {
            Conference conference = conferenceList.get(i);
            System.out.println(conference.getStart_date());
        }
    }
}