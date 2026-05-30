import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.impl.ConferenceDaoImpl;
import com.demo.web_project.vo.Conference;
import org.junit.jupiter.api.Test;

public class FindConferenceTest {
    private ConferenceDao conferenceDao= new ConferenceDaoImpl();
    @Test
    public void testcode(){
        String code="7aB9cD2eF";
        Conference conference=conferenceDao.findByCodes(code);
        System.out.println(conference.getTitle());
    }
    public  void testkeyword(){

    }
}
