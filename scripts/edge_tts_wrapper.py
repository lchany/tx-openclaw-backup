#!/usr/bin/env python3
"""Edge TTS wrapper for OpenClaw"""

import asyncio
from edge_tts import Communicate
import sys
import uuid
import json

async def main():
    # Read text from stdin or arguments
    if len(sys.argv) > 1:
        text = sys.argv[1]
    else:
        text = sys.stdin.read().strip()
    
    if not text:
        print("Error: No text provided", file=sys.stderr)
        sys.exit(1)
    
    # Generate unique filename
    output_file = f"/tmp/edge_tts_{uuid.uuid4().hex}.mp3"
    
    # Use XiaoxiaoNeural for natural Chinese voice
    communicate = Communicate(text, "zh-CN-XiaoxiaoNeural")
    await communicate.save(output_file)
    
    # Print the file path
    print(output_file)

if __name__ == "__main__":
    asyncio.run(main())
