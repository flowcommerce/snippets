import com.google.inject.name.Names
import play.api.inject.{BindingKey, QualifierInstance}

lazy val actor = play.api.Play.current.injector.instanceOf(
  BindingKey(classOf[ActorRef], Some(QualifierInstance(Names.named("localized-item-event-processor"))))
)
