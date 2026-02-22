#!/usr/bin/env python3
"""Vosk STT wrapper for OpenClaw"""

import os
import sys
import json

MODEL_PATH = "/home/lchych/vosk-model-cn/vosk-model-small-cn-0.22"

def main():
    if len(sys.argv) < 2:
        print("Usage: vosk_stt.py <audio_file>", file=sys.stderr)
        sys.exit(1)
    
    audio_file = sys.argv[1]
    
    if not os.path.exists(audio_file):
        print(f"Error: File not found: {audio_file}", file=sys.stderr)
        sys.exit(1)
    
    # Convert to wav if needed using ffmpeg
    import subprocess
    wav_file = "/tmp/vosk_input.wav"
    
    try:
        # Try to convert to wav 16kHz mono
        subprocess.run([
            "ffmpeg", "-y", "-i", audio_file,
            "-ar", "16000", "-ac", "1", "-acodec", "pcm_s16le",
            wav_file
        ], capture_output=True, timeout=60)
    except Exception as e:
        print(f"Error converting audio: {e}", file=sys.stderr)
        # Try original file
        wav_file = audio_file
    
    # Run Vosk recognition
    from vosk import Model, Recognizer, KaldiRecognizer
    import wave
    
    model = Model(MODEL_PATH)
    
    wf = wave.open(wav_file, "rb")
    rec = KaldiRecognizer(model, wf.getframerate())
    
    result_text = ""
    while True:
        data = wf.readframes(4000)
        if len(data) == 0:
            break
        if rec.AcceptWaveform(data):
            result = json.loads(rec.Result())
            result_text += result.get("text", "") + " "
    
    final_result = json.loads(rec.FinalResult())
    result_text += final_result.get("text", "")
    
    print(result_text.strip())

if __name__ == "__main__":
    main()
