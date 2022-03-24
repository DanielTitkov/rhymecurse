package configs

type (
	DataConfig struct {
		Presets PresetsConfig
	}
	PresetsConfig struct {
		TaskPresetsPaths []string `yaml:"taskPresetsPaths"`
	}
)
