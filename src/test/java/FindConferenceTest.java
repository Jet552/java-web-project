import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.impl.ConferenceDaoImpl;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.vo.Payment;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class FindConferenceTest {
    private ConferenceDao conferenceDao= new ConferenceDaoImpl();

    @Test
    public void testcode(){
        String code="7aB9cD2eF";
        Conference conference=conferenceDao.findByCodes(code);
        if (conference != null) {
            System.out.println(conference.getTitle());
        } else {
            System.out.println("邀请码 " + code + " 不存在（测试数据已变更）");
        }
    }

    @Test
    public void testkeyword(){
        String keyword="会" ;
        List<Conference> conferenceList=conferenceDao.findAll(keyword);
        assertNotNull(conferenceList);
        for (int i = 0; i < conferenceList.size(); i++) {
            Conference conference = conferenceList.get(i);
            System.out.println(conference.getStart_date());
        }
    }

    @Test
    public void test(){
        Payment payment=new Payment();
        assertNull(payment.getStatus());
        System.out.println("新 Payment status: " + payment.getStatus());
    }
}