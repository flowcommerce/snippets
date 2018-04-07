package util

import scala.annotation.tailrec
import scala.util.{Failure, Success, Try}

/**
  * Represents a fraction like 1/3
  */
case class Fraction(n: Int, d: Int) {

  val label = if (n == 0 || d == 1) {
    n.toString
  } else if (n == d) {
    "1"
  } else {
    s"$n/$d"
  }

  def toBigDecimal: BigDecimal = BigDecimal(n*1.0) / BigDecimal(d*1.0)

  def +(f: Fraction): Fraction = {
    Fraction((n * f.d) + (f.n * d), d * f.d).reduce()
  }

  def *(multiple: Long): Fraction = {
    Fraction(n * multiple.toInt, d).reduce()
  }

  def reduce(): Fraction = {
    val g = gcd(Math.abs(n), Math.abs(d))
    Fraction(n / g, d / g)
  }

  // Determines the greatest common divisor of two numbers
  @tailrec
  private[this] def gcd(a: Int, b: Int) : Int = {
    if (b == 0) {
      a
    } else {
      gcd(b, a % b)
    }
  }

}

object Fraction {

  def apply(value: String): Fraction = {
    fromString(value) match {
      case Left(errors) => sys.error(s"Invalid fraction[$value]: ${errors.mkString(", ")}")
      case Right(f) => f
    }
  }

  def sum(values: Seq[Fraction]): Fraction = {
    values.toList match {
      case Nil => Fraction(0, 1)
      case _ => values.reduceLeft(_ + _)
    }
  }

  def fromString(value: String): Either[Seq[String], Fraction] = {
    value.split("/").toList match {
      case a :: Nil => {
        Left(Seq(s"Invalid fraction[$value] - missing '/'"))
      }

      case n :: d :: Nil => {
        Try {
          Fraction(n.trim.toInt, d.trim.toInt)
        } match {
          case Success(f) => {
            if (f.d == 0) {
              Left(Seq(s"Denominator[${f.d}] must be > 0"))
            } else {
              Right(f)
            }
          }

          case Failure(_) => {
            Left(Seq(s"Numerator and denominator must be integers: $value"))
          }
        }
      }

      case _ => {
        Left(Seq(s"Invalid fraction[$value]"))
      }

    }
  }

}