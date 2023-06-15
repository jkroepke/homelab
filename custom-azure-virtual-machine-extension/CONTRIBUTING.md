Azure VM extensions are lightweight applications that handle post-deployment configuration and automation tasks on Azure VMs. Azure hosts many extensions for e.g. VM configuration, monitoring, security, and utility applications. Publishers take an application, then wrap it into an extension, and simplify the installation, so all users need to do is provide mandatory parameters

The main source code is structured in 2 parts:
- handler - contains the windows/linux related scripts that need to install needed dependencies on the vm, download the Custom Agent install it and enroll it to Fleet
- packages - contains the UI and miscellaneous installation scripts 

## Handler

The handler implements the Windows Azure Agent defined protocol to integrate with the Azure ecosystem. 

Handler requirements:

1. Handler Packaging – The handler should be packaged as a zip file. This zip package should contain all the binaries related to the handler and HandlerManifest. This package needs to be registered with the Azure image repository. Azure image repository is responsible for managing all versions of all the handlers that are registered with the Azure ecosystem.

2. Handler Environment - The handler needs the capability to read the environment file in the format that Azure Agent defines. The environment file defines the locations of various files and folders that the handler needs to use for reading configuration and writing back heartbeat and status.

3. Handler Configuration – Various extension packs that the handler needs to manage are passed to the handler in form of configuration settings. For example if a script is needed by the handler to install an extension, that script is passed to it via the handler configuration file. The handler should have the ability to read this file in the format defined by the Azure Agent and should be able to execute its contents and report the status of that execution with a frequency that complies with the Azure Agent protocol.

4. Handler heartbeat and status – The handler is supposed to report the status of the most recently executed configuration with a frequency that complies with the Azure Agent protocol. In addition to status, if the handler opts into reporting heartbeat it needs to report the heartbeat for the complete lifetime of the handler on the VM with a frequency that complies with the Azure Agent protocol. 
 

### Handler Package

This is the package that contains the handler binary files and all standard static configuration files. It is registered with the azure ecosystem and will contain the binaries and the HandlerManifest.json file that is used by the Azure Agent to manage the handler.
 Since we are supporting both Windows and Linux os’s `handler` directory is divided into `windows` and `linux` handler packages for each os version.
Ex. HandlerManifest.json

----
    [{
    "version": 1.0,
    "handlerManifest": {
        "installCommand": "scripts\\windows\\install.cmd",
        "uninstallCommand": "scripts\\windows\\uninstall.cmd",
        "updateCommand": "scripts\\windows\\update.cmd",
        "enableCommand": "scripts\\windows\\enable.cmd",
        "disableCommand": "scripts\\windows\\disable.cmd",
        "rebootAfterInstall": false,
        "reportHeartbeat": false
    }
    }]
----

Custom Agent Handler Package structure

Binaries will be composed of .cmd, .ps1 and .sh files.

Install command:
- should download and install the necessary dependencies for the Custom Agent to be installed.

Enable command:
- will ping 
- will download the Custom Agent
- will install the Custom Agent 
- and start it

Will also handled cases like update configuration or start vm

Disable command:
 - Should only stop the service (cmd documented in Custom Agent docs)

Uninstall command:
- Should uninstall the service. For deb and rpm, additional effort is made in order to unenroll the agent (api call), stop the agent and remove the Custom Agent folders

Update command:
- Should re-install a new instance of Custom Agent


### Handler Environment
 This is the set of files and folders that the Azure Agent sets up for the handlers to use at runtime. These files can be used for communicating with the Azure Agent (heartbeat and status) or for writing debugging information (logging). 

Ex:
---
    [{
    "version": 1.0,
    "handlerEnvironment": {
    "logFolder": "<your log folder location>",
    "configFolder": "<your config folder location>",
    "statusFolder": "<your status folder location>",
    "heartbeatFile": "<your heartbeat file location>",
    "deploymentid": "<deployment id for the vm>",
    "rolename": "<role name for the vm>",
    "instance": "<instance name for the vm>"
    }
    }]
---
`logFolder` - contains the location where the handler should put its log files that might be needed to debug any customer issues. The advantage of putting log files under the folder directed by this location is that these files can be automatically retrieved from the customers VM by using a tool, without actually logging into the VM and copying them over manually. 
`configFolder` - contains the location where the handler will get its configuration settings file. 
`statusFolder` - contains the location where the handler is supposed to write back a file with a structured status of the current state of the work being done by the handler. heartbeatFile - this is the file that is used to communicate the heartbeat of the handler back to the Azure Agent. 
`deploymentid` - this is the deployment id which the vm belongs to. This may change when a VM is captured/backed-up and restored. 
`rolename` -  this is the role name of the vm. This may change when a VM is captured/backed up and restored. 
`instance` - this is the instance name of the vm (can be same as role name)

### Handler Configuration
This is a configuration file that contains various settings needed to configure this handler at runtime. Extension configuration is the input provided by the end user based on the schema provided by the handler publisher during registration.
The location where the configuration setting files will be written can be retrieved by the “configFolder” property in the HandlerEnvironment.json file.


There are many ways to contribute, from writing tutorials or blog posts, improving the documentation, submitting bug reports and feature requests or writing code .
