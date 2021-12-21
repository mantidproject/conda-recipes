import mantid.kernel
import mantid.geometry
import mantid.api

# Turn off network required things that the framework does
from mantid.kernel import ConfigService
ConfigService["UpdateInstrumentDefinitions.OnStartup"] = "0"
ConfigService["usagereports.enabled"] = "0"
ConfigService["CheckMantidVersion.OnStartup"] = "0"

import mantid.simpleapi