import java.io.File;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

/**
 * JMeter新版本csv形式JTL分析器
 * @author tinghe
 * @version $Id: JTLParser.java, v 0.1 2013-6-28 下午2:27:42 tinghe Exp $
 */
public class JTLParser {
    private String                    jtlFile = "";
    private Scanner                   scanner;
    private Map<Long, TimeUnitSample> sample  = new HashMap<Long, TimeUnitSample>();
    private List<Long>                points  = new ArrayList<Long>();
    private SimpleDateFormat          sdf     = new SimpleDateFormat("HH:mm:ss");

    public JTLParser(String jtlFile) {
        this.jtlFile = jtlFile;
    }

    public void parse() throws FileNotFoundException {
        scanner = new Scanner(new File(jtlFile));
        while (scanner.hasNext()) {
            String line = scanner.nextLine();
            parseLine(line);
        }
        scanner.close();
    }

    protected void parseLine(String line) {
        if (line != null) {
            String[] parts = line.split(",");
            if (parts.length == 10) {
                long time = Long.valueOf(parts[0]);
                long cost = Long.valueOf(parts[1]);
                //                String method = parts[2];
                //                String repsCode = parts[3];
                //                String repsResult = parts[4];
                //                String thread = parts[5];
                //                String type = parts[6];
                //                String success = parts[7];
                long sec = time / 1000;
                TimeUnitSample oneSample = new TimeUnitSample(cost, 1);
                if (sample.containsKey(sec)) {
                    sample.get(sec).add(oneSample);
                } else {
                    points.add(sec);
                    sample.put(sec, oneSample);
                }
            }
        }
    }

    public static void main(String[] args) throws FileNotFoundException {
        String jtlFile = "/opt/installPackage/apache-jmeter-2.7/sla/14:56:36-15:02:53/test1.jtl";
        JTLParser jtlParser = new JTLParser(jtlFile);
        jtlParser.parse();
        jtlParser.print();
    }

    public void print() {
        System.out.println("time\tsecond\ttps\tcost");
        for (Long time : points) {
            TimeUnitSample unit = sample.get(time);
            String strTime = sdf.format(new Date(time * 1000));
            System.out.println(time + "\t" + strTime + "\t" + unit.getCount() + "\t"
                               + unit.getCost() / unit.getCount());
        }
    }

    class TimeUnitSample {
        private long cost;
        private long count;

        public TimeUnitSample(long cost, long count) {
            this.cost = cost;
            this.count = count;
        }

        public void add(TimeUnitSample sample) {
            this.cost += sample.getCost();
            this.count += sample.getCount();
        }

        public long getCost() {
            return cost;
        }

        public void setCost(long cost) {
            this.cost = cost;
        }

        public long getCount() {
            return count;
        }

        public void setCount(long count) {
            this.count = count;
        }

    }
}
