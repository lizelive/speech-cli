{ lib
, fetchPypi
, buildPythonPackage
, requests
, typing-extensions
, openai-whisper
, pyaudio
}:

buildPythonPackage rec {
  pname = "SpeechRecognition";
  version = "3.10.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cYcxiGt4NuIKBrmixsrOEqnhMJcbtq8bHdEwsiutn4I=";
  };

  propagatedBuildInputs = [
    requests
    typing-extensions
    openai-whisper
    pyaudio
  ];


  pythonImportsCheck = [ "speech_recognition" ];
  doCheck = false;
  
  meta = with lib; {
    description = "Library for performing speech recognition, with support for several engines and APIs, online and offline";
    homepage = "https://pypi.org/project/SpeechRecognition/";
    license = with licenses; [ gpl2Only bsd3 bsd2 ];
    maintainers = with maintainers; [ lizelive ];
  };
}
