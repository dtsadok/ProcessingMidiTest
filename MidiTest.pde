//Java MIDI docs/articles:
//http://patater.com/gbaguy/javamidi.htm
//http://www.ibm.com/developerworks/library/it/it-0801art38/
//http://docs.oracle.com/javase/tutorial/sound/MIDI-synth.html
//http://docs.oracle.com/javase/7/docs/api/javax/sound/midi/MidiSystem.html

import javax.sound.midi.*;

//program options
final boolean PlayNotes = true;
final boolean PlayMidiFile = true;
final boolean PrintSoundbankInfo = true;
final boolean PrintSequenceInfo = true;

Synthesizer synth;
Sequencer sequencer;

void setup()
{
  //setup MIDI
  try {
    synth = MidiSystem.getSynthesizer();
    synth.open();

    sequencer = MidiSystem.getSequencer();
    sequencer.open();
  } 
  catch (MidiUnavailableException e) {
    println("Midi does not appear to be supported.");
    exit();
  }

  if (PlayNotes)
    playNotes();

  if (PlayMidiFile)
    selectInput("Select a MIDI file to play:", "playMidiFile");

  noLoop();
}

void draw() {
}

//go through every instrument and play a note
void playNotes() {
  Instrument[] instr = synth.getLoadedInstruments();

  MidiChannel[] channels = synth.getChannels();
  MidiChannel ch = channels[0];

  int note = 60; //middle C = 60
  int velocity = 600;

  for (int i=0; i < instr.length ; i++)
  {
    println(i + ":" + instr[i].getName());

    ch.programChange(i); //set instrument
    ch.noteOn(note, velocity);
    sleep(1000);
    ch.noteOff(note, velocity);
  }
}

void playMidiFile(File midiFile) {
  if (midiFile == null) {
    println("No file to play.");
    return;
  }

  try {
    Sequence sequence = MidiSystem.getSequence( midiFile );

    if (PrintSequenceInfo) printSequenceInfo(sequence);

    sequencer.setSequence(sequence);
    sequencer.start();
  }
  catch (InvalidMidiDataException e) {
    println("caught InvalidMidiDataException");
    return;
  }
  catch (IOException e) {
    println("caught IOException");
    return;
  }
}

void printSoundbankInfo() {
  Soundbank soundbank = synth.getDefaultSoundbank();
  println( soundbank.getName() );
  println( soundbank.getDescription() );
  println( soundbank.getVendor() );
}

void printSequenceInfo(Sequence sequence)
{
  Track [] tracks = sequence.getTracks();

  println( " length: " + 
    sequence.getTickLength() + " ticks" );
  println( " duration: " + 
    sequence.getMicrosecondLength() +  " micro seconds" );
  println("Number of tracks: " + tracks.length);

}

void sleep(int millis) {
  try
  {
    Thread.sleep(millis);
  } 
  catch (InterruptedException e) {
  }
}

