import java.nio.file.{Files, Path}
import java.util.zip.{ZipEntry, ZipOutputStream}

case class Attachment(name: String, path: Path)

object App {

  def createZip(attachments: Seq[Attachment]) {
    val tmpFile = File.createTempFile(s"zip", ".zip.tmp")
    val zip = new ZipOutputStream(Files.newOutputStream(tmpFile.toPath))

    attachments.foreach { attachment =>
      zip.putNextEntry(new ZipEntry(attachment.name))
      Files.copy(attachment.path, zip)
      zip.closeEntry()
    }

    zip.close()
  }
}
