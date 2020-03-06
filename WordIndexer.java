import java.io.IOException;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Set;
import java.util.StringTokenizer;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class WordIndexer {

    public static class LineToWordOccurrencesMapper extends Mapper<Object, Text, Text, Text> {

        private static Text hadoopText = new Text();
        private static Text hadoopTextValue = new Text();

        public void map(Object key, Text value, Context context) throws IOException, InterruptedException {

            // [word][filename;byteoffset]

            String fileName = ((FileSplit) context.getInputSplit()).getPath().getName();
            String line = value.toString().replaceAll("[^a-zA-Z0-9]+", " ");

            StringTokenizer lineTokenizer = new StringTokenizer(line);

            while (lineTokenizer.hasMoreTokens()) {
                String word = lineTokenizer.nextToken().toLowerCase();

                if (word.length() > 1) {
                    hadoopText.set(word);
                    hadoopTextValue.set(fileName + ";" + String.valueOf(key));
                    context.write(hadoopText, hadoopTextValue);
                }
            }
        }
    }

    public static class WordOccurrencesReducer extends Reducer<Text, Text, Text, Text> {

        private Text result = new Text();

        public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {

            if (!values.iterator().hasNext()) { return; }

            String word = key.toString();
            Hashtable<String, ArrayList<Long>> wordOccurrencesInFiles = new Hashtable<String, ArrayList<Long>>();

            for (Text value : values) {

                String[] fileNameAndLineOffset = value.toString().split(";");

                if (fileNameAndLineOffset.length < 2) {
                    System.out.println("Unable to reduce: " + value.toString());
                    continue;
                }

                String fileName = fileNameAndLineOffset[0];
                Long lineOffset = Long.parseLong(fileNameAndLineOffset[1]);

                if (!wordOccurrencesInFiles.containsKey(fileName)) {
                    ArrayList<Long> lineOffsets = new ArrayList<Long>();
                    wordOccurrencesInFiles.put(fileName, lineOffsets);
                }

                wordOccurrencesInFiles.get(fileName).add(lineOffset);
            }

            StringBuilder reducedValueBuilder = new StringBuilder();

            Set<String> fileNames = wordOccurrencesInFiles.keySet();
            for (String fileName : fileNames) {
                reducedValueBuilder.append("\n  " + fileName);

                ArrayList<Long> offsets = wordOccurrencesInFiles.get(fileName);
                for (long offset : offsets) {
                    reducedValueBuilder.append(" " + offset);
                }
            }

            reducedValueBuilder.append("\n");

            String reducedValue = reducedValueBuilder.toString();
            result.set(reducedValue);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "Word indexer");

        job.setJarByClass(WordIndexer.class);

        job.setMapperClass(LineToWordOccurrencesMapper.class);
        job.setReducerClass(WordOccurrencesReducer.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
