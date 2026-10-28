package com.hmcts.cvp.wowza;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.wowza.wms.livestreamrecord.manager.IStreamRecorder;
import com.wowza.wms.livestreamrecord.manager.IStreamRecorderActionNotify;

public class CrimeSegmentEndTimeListener implements IStreamRecorderActionNotify
{
    private static final Logger LOGGER = Logger.getLogger(CrimeSegmentEndTimeListener.class.getName());

    private final Map<IStreamRecorder, Long> segmentStartTimes = new ConcurrentHashMap<>();

    @Override
    public void onSegmentStart(IStreamRecorder recorder)
    {
        segmentStartTimes.put(recorder, System.currentTimeMillis());
    }

    @Override
    public void onSegmentEnd(IStreamRecorder recorder)
    {
        long endTime = System.currentTimeMillis();
        Long startTime = segmentStartTimes.remove(recorder);
        if (startTime == null)
            LOGGER.warning("No segment start time was recorded for the completed segment");
        else
            LOGGER.fine("Completed segment duration: " + (endTime - startTime) + "ms");

        String recordingPath = recorder.getCurrentFile();
        if (recordingPath == null || recordingPath.length() == 0)
            recordingPath = recorder.getFilePath();
        if (recordingPath == null || recordingPath.length() == 0)
        {
            LOGGER.severe("Could not determine the completed recording path");
            return;
        }

        File recording = new File(recordingPath);
        if (!recording.isFile())
        {
            LOGGER.severe("Completed recording file does not exist: " + recording.getAbsolutePath());
            return;
        }

        File renamedRecording = new File(recording.getParentFile(),
                appendEndTime(recording.getName(), endTime));
        try
        {
            Files.move(recording.toPath(), renamedRecording.toPath());
            LOGGER.info("Renamed completed crime segment to " + renamedRecording.getAbsolutePath());
        }
        catch (IOException e)
        {
            LOGGER.log(Level.SEVERE, "Could not rename completed crime segment " + recording.getAbsolutePath(), e);
        }
    }

    private String appendEndTime(String fileName, long endTime)
    {
        int extensionIndex = fileName.lastIndexOf('.');
        String baseName = extensionIndex > 0 ? fileName.substring(0, extensionIndex) : fileName;
        String extension = extensionIndex > 0 ? fileName.substring(extensionIndex) : "";

        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd'T'HHmmss.SSS'Z'", Locale.ROOT);
        formatter.setTimeZone(TimeZone.getTimeZone("UTC"));
        return baseName + "_" + formatter.format(new Date(endTime)) + extension;
    }
}
