import os

from leapp.actors import Actor
from leapp.libraries.stdlib import run, CalledProcessError
from leapp.reporting import Report, create_report
from leapp import reporting
from leapp.tags import FirstBootPhaseTag, IPUWorkflowTag


class UpdateCagefs(Actor):
    """
    Force update of cagefs.

    cagefs should reflect massive changes in system made in previous phases
    """

    name = 'update_cagefs'
    consumes = ()
    produces = (Report,)
    tags = (FirstBootPhaseTag, IPUWorkflowTag)

    def process(self):
        if os.path.exists('/usr/sbin/cagefsctl'):
            try:
                run(['/usr/sbin/cagefsctl', '--force-update'], checked=True)
                self.log.info('cagefs update was successful')
            except CalledProcessError:
                self.log.error('Something went wrong during "cagefsctl --force-update", file system inside cagefs may by out-of-date.\n'
                    'Check /var/log/cagefs-update.log and rerun "cagefsctl --force-update" after fixing the issues.')

