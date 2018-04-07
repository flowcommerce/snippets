package util

import org.scalatestplus.play.PlaySpec
import org.scalatestplus.play.guice.GuiceOneAppPerSuite


class FractionSpec extends PlaySpec with db.Helpers with GuiceOneAppPerSuite {

  def validateError(fraction: String, message: String): Unit = {
    Fraction.fromString(fraction) match {
      case Left(error) => error must equal(Seq(message))
      case Right(_) => sys.error(s"Expected error for fraction[$fraction]")
    }
  }

  "fromString validates" in {
    validateError("x", "Invalid fraction[x] - missing '/'")
    validateError("1/2/3", "Invalid fraction[1/2/3]")
    validateError("1/0", "Denominator[0] must be > 0")
  }

  "valid fractions" in {
    Fraction("1/2").label must equal("1/2")
    Fraction("  2 /  9 ").label must equal("2/9")
  }

  "addition" in {
    (Fraction("1/4") + Fraction("1/4")).label must equal("1/2")
    (Fraction("1/2") + Fraction("1/2")).label must equal("1")
    (Fraction("1/2") + Fraction("3/2")).label must equal("2")
  }

  "multiplication" in {
    (Fraction("1/4") * 2).label must equal("1/2")
    (Fraction("2/4") * 3).label must equal("3/2")
    (Fraction("2/4") * 0).label must equal("0")
    (Fraction("2/4") * -1).label must equal("-1/2")
  }

  "label" in {
    Fraction("1/4").label must equal("1/4")
    Fraction("2/4").label must equal("2/4")
    Fraction("4/4").label must equal("1")
  }

  "toBigDecimal" in {
    Fraction("1/4").toBigDecimal must equal(BigDecimal(0.25))
  }

  "Fraction.sum" in {
    Fraction.sum(
      Seq(
        Fraction("1/3"),
        Fraction("2/3")
      )
    ).label must equal("1")
  }

}
