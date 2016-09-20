/**
  * Download url to a string, and write that string to a temporary
  * file.
  */

import java.io.File
import java.nio.file.{Paths, Files}
import java.nio.charset.StandardCharsets
import scala.io.Source

val tmpFile = java.io.File.createTempFile("url", ".tmp");
val contents = scala.io.Source.fromURL(new java.net.URL(url),  "UTF-8").mkString
Files.write(Paths.get(tmpFile.toString), "file contents".getBytes(StandardCharsets.UTF_8))
tmpFile

