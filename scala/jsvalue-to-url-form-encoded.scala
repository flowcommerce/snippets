import java.net.URLEncoder
import play.api.libs.json._

/**
  * Converts the specified js value into a url form encoded string,
  * recursively through all types.
  *
  * See https://github.com/flowcommerce/lib-apidoc-json-validation/blob/master/src/main/scala/io/flow/apidoc-json-validation/FormData.scala
  *
  * @oaram keys Keeps track of the top level keys we are parsing to
  *        build up nested keys (e.g. user[first] for maps)
  */
def toEncoded(js: JsValue, keys: Seq[String] = Nil): String = {
  js match {
    case o: JsObject => {
      o.value.map { case (key, value) =>
        toEncoded(value, keys ++ Seq(key))
      }.mkString("&")
    }
    case o: JsArray => {
      o.value.map { v =>
        toEncoded(v, keys)
      }.mkString("&")
    }
    case o: JsString => encode(o.value, keys)
    case o: JsBoolean => encode(o.value.toString, keys)
    case o: JsNumber => encode(o.value.toString, keys)
    case JsNull => encode("", keys)
    case other => encode(other.toString, keys)
  }
}

private[this] def encode(value: String, keys: Seq[String] = Nil): String = {
  val enc = URLEncoder.encode(value, "UTF-8")
  keys.toList match {
    case Nil => enc
    case one :: rest => {
      s"%s=%s".format(buildKey(rest, one), enc)
    }
  }
}

@scala.annotation.tailrec
private[this] def buildKey(values: Seq[String], result: String): String = {
  values.toList match {
    case Nil => result
    case one :: rest => {
      buildKey(rest, s"$result[$one]")
    }
  }
}
