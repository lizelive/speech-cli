#! /usr/bin/env python3
import time

import speech_recognition as sr
from transformers import pipeline
from datasets import load_dataset
import soundfile as sf
import torch


# The recognition language is determined by language, an uncapitalized full language name like "english" or "chinese". See the full language list at https://github.com/openai/whisper/blob/main/whisper/tokenizer.py




WHISPER_MODEL = "tiny.en"
"""
small	244 M	small.en	small	~2 GB	~6x
model can be any of tiny, base, small, medium, large, tiny.en, base.en, small.en, medium.en. See https://github.com/openai/whisper for more details.
"""

def asr():
    # NOTE: this example requires PyAudio because it uses the Microphone class
    # this is called from the background thread
    def callback(recognizer, audio):
        # received audio data, now we'll recognize it using Google Speech Recognition
        try:
            print("whisper thinks you said " + recognizer.recognize_whisper(audio, language="en", model = WHISPER_MODEL))
        except sr.UnknownValueError:
            print("whisper could not understand audio")
        except sr.RequestError as e:
            print("Could not request results from whisper service; {0}".format(e))


    r = sr.Recognizer()
    m = sr.Microphone()
    with m as source:
        r.adjust_for_ambient_noise(source)  # we only need to calibrate once, before we start listening

    # start listening in the background (note that we don't have to do this inside a `with` statement)
    stop_listening = r.listen_in_background(m, callback)
    # `stop_listening` is now a function that, when called, stops background listening

    # do some unrelated computations for 5 seconds
    # for _ in range(50): time.sleep(0.1)  # we're still listening even though the main thread is doing other things
    input("Press enter to stop listening: ")

    # calling this function requests that the background listener stop listening
    stop_listening(wait_for_stop=True)

    # do some more unrelated things
    # while True: time.sleep(0.1)  # we're not listening anymore, even though the background thread might still be running for a second or two while cleaning up and stopping

    print("done")


def main():
    synthesiser = pipeline("text-to-speech", "microsoft/speecht5_tts")

    embeddings_dataset = load_dataset("~/.cache/huggingface/datasets/Matthijs___cmu-arctic-xvectors/default/0.0.1/a62fea1f9415e240301ea0042ffad2a3aadf4d1caa7f9a8d9512d631723e781f/", split="validation")
    speaker_embedding = torch.tensor(embeddings_dataset[7306]["xvector"]).unsqueeze(0)
    print(speaker_embedding)
    # You can replace this embedding with your own as well.

    speech = synthesiser("Hello, my dog is cooler than you!", forward_params={"speaker_embeddings": speaker_embedding})

    sf.write("speech.wav", speech["audio"], samplerate=speech["sampling_rate"])