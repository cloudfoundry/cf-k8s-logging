package integration_test

import (
	"fmt"
	"os"
	"strings"
	"time"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	. "github.com/onsi/gomega/gexec"

	"github.com/cloudfoundry-incubator/cf-test-helpers/cf"
	"github.com/cloudfoundry-incubator/cf-test-helpers/generator"
)

const NamePrefix = "cf-k8s-logging-integration"

func GetRequiredEnvVar(envVarName string) string {
	value, ok := os.LookupEnv(envVarName)
	if !ok {
		panic(envVarName + " environment variable is required, but was not provided.")
	}
	return value
}

var _ = Describe("Smoke Tests", func() {
	var (
		orgName string
		appName string
	)

	BeforeEach(func() {
		apiEndpoint := GetRequiredEnvVar("TEST_API_ENDPOINT")
		username := GetRequiredEnvVar("TEST_USERNAME")
		password := GetRequiredEnvVar("TEST_PASSWORD")

		apiArguments := []string{"api", apiEndpoint}
		_, ok := os.LookupEnv("TEST_SKIP_SSL")
		if ok {
			apiArguments = append(apiArguments, "--skip-ssl-validation")
		}

		// Target CF and auth
		cfAPI := cf.Cf(apiArguments...)
		Eventually(cfAPI).Should(Exit(0))

		// Authenticate
		Eventually(func() *Session {
			return cf.CfRedact(password, "auth", username, password).Wait()
		}, 1*time.Minute, 2*time.Second).Should(Exit(0))

		// Create an org and space and target
		orgName = generator.PrefixedRandomName(NamePrefix, "org")
		spaceName := generator.PrefixedRandomName(NamePrefix, "space")

		Eventually(cf.Cf("create-org", orgName)).Should(Exit(0))
		Eventually(cf.Cf("create-space", "-o", orgName, spaceName)).Should(Exit(0))
		Eventually(cf.Cf("target", "-o", orgName, "-s", spaceName)).Should(Exit(0))

		// Enable Docker Feature Flag
		Eventually(cf.Cf("enable-feature-flag", "diego_docker")).Should(Exit(0))
	})

	AfterEach(func() {
		if CurrentGinkgoTestDescription().Failed {
			printAppReport(appName)
		}

		if orgName != "" {
			// Delete the test org
			Eventually(func() *Session {
				return cf.Cf("delete-org", orgName, "-f").Wait()
			}, 2*time.Minute, 1*time.Second).Should(Exit(0))
		}
	})

	It("Logs are egressed from an app", func() {
		appName = generator.PrefixedRandomName(NamePrefix, "app")

		By("pushing an app and checking that the CF CLI command succeeds")
		cfPush := cf.Cf("push", appName, "-o", "oratos/logspewer")
		Eventually(cfPush).Should(Exit(0))

		By("verifying that the application's logs are available.")
		Eventually(func() string {
			cfLogs := cf.Cf("logs", appName, "--recent")
			return string(cfLogs.Wait().Out.Contents())
		}, 2*time.Minute, 2*time.Second).Should(ContainSubstring("Log Message"))
	})
})

func printAppReport(appName string) {
	if appName == "" {
		return
	}

	printAppReportBanner(fmt.Sprintf("***** APP REPORT: %s *****", appName))
	Eventually(cf.Cf("app", appName, "--guid")).Should(Exit())
	Eventually(cf.Cf("logs", "--recent", appName)).Should(Exit())
	printAppReportBanner(fmt.Sprintf("*** END APP REPORT: %s ***", appName))
}

func printAppReportBanner(announcement string) {
	sequence := strings.Repeat("*", len(announcement))
	fmt.Fprintf(GinkgoWriter, "\n\n%s\n%s\n%s\n", sequence, announcement, sequence)
}
