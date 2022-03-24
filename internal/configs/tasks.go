package configs

type TaskConfig struct {
	DefaultSchedule    string `yaml:"defaultSchedule"`
	DefaultRetryNumber int    `yaml:"defaultRetryNumber"`
	DefaultRetryDelay  string `yaml:"defaultRetryDelay"`
	MaxConcurrency     int    `yaml:"maxConcurrency"`
}
