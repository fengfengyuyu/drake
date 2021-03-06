% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/triggers.R
\name{trigger}
\alias{trigger}
\title{Set the trigger of a target.}
\usage{
trigger(command = TRUE, depend = TRUE, file = TRUE,
  condition = NULL, change = NULL)
}
\arguments{
\item{command}{logical, whether to rebuild the target if the
\code{\link[=drake_plan]{drake_plan()}} command changes.}

\item{depend}{logical, whether to rebuild if a
non-file dependency changes.}

\item{file}{logical, whether to rebuild the target
if a \code{\link[=file_in]{file_in()}}/\code{\link[=file_out]{file_out()}}/\code{\link[=knitr_in]{knitr_in()}} file changes.}

\item{condition}{R code (expression or language object)
that returns a logical. The target will rebuild
if the code evaluates to \code{TRUE}.}

\item{change}{R code (expression or language object)
that returns any value. The target will rebuild
if that value is different from last time
or not already cached.}
}
\value{
a list of trigger specification details that
\code{drake} processes internally when it comes time to decide
whether to build the target.
}
\description{
For details, see the chapter on triggers
in the user manual:
\url{https://ropenscilabs.github.io/drake-manual}
}
\details{
Use this function inside a target's command
in your \code{\link[=drake_plan]{drake_plan()}}. The target will rebuild if and only if:
\itemize{
\item Any of \code{command}, \code{depend}, or \code{file} is \code{TRUE}, or
\item \code{condition} evaluates to \code{TRUE}, or
\item \code{change} evaluates to a value different from last time.
There may be a slight efficiency loss if you set complex
triggers for \code{change} and/or \code{condition} because
\code{drake} needs to load any required dependencies
into memory before evaluating these triggers.
}
}
\examples{
# A trigger is just a set of decision rules
# to decide whether to build a target.
trigger()
# This trigger will build a target on Tuesdays
# and when the value of an online dataset changes.
trigger(condition = today() == "Tuesday", change = get_online_dataset())
\dontrun{
test_with_dir("Quarantine side effects.", {
load_mtcars_example() # Get the code with drake_example("mtcars").
# You can use a global trigger argument:
# for example, to always run everything.
make(my_plan, trigger = trigger(condition = TRUE))
make(my_plan, trigger = trigger(condition = TRUE))
# You can also define specific triggers for each target.
plan <- drake_plan(
  x = rnorm(15),
  y = target(
    command = x + 1,
    trigger = trigger(depend = FALSE)
  )
)
# Now, when x changes, y will not.
make(plan)
make(plan)
plan$command[1] <- "rnorm(16)" # change x
make(plan)
})
}
}
\seealso{
\code{\link[=drake_plan]{drake_plan()}}, \code{\link[=make]{make()}}
}
