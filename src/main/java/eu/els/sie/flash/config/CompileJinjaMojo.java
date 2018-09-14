package eu.els.sie.flash.config;

import com.hubspot.jinjava.Jinjava;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.yaml.snakeyaml.Yaml;

import java.io.File;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/**
 * Goal which renders a jinja file
 */
@Mojo(name = "renderjinja") public class CompileJinjaMojo extends AbstractMojo {

	/**
	 * Variables directory.
	 */
	@Parameter(property = "variablesDirectory") private File variablesDirectory;

	/**
	 * Location of the template files.
	 */
	@Parameter(property = "templatesDirectory") private File templatesDirectory;

	/**
	 * out put directory.
	 */
	@Parameter(property = "outputDirectory") private File outputDirectory;

	/**
	 * used profile.
	 */
	@Parameter(property = "profile") private String profile;

	/**
	 * encoding.
	 */
	@Parameter(property = "encoding", defaultValue = "Cp1252") private String encoding;

	public void execute() throws MojoExecutionException {
		try {
			// Validate the plugin provided configuration.
			validatePluginConfig();

			// Process template
			processTemplates();

		} catch (Exception e) {
			// Print error and exit with -1
			getLog().debug("An exception occurred " + e.getMessage());
			throw new MojoExecutionException(e.getLocalizedMessage(), e);
		}
	}


	/**
	 * Load variables file in the context.
	 * @param variablesFile variables file.
	 * @param context context to use
	 */
	private void loadVariablesInContext(Map<String, Object> context,File variablesFile){
		if(variablesFile.isDirectory()){
			File[] files = variablesFile.listFiles();
			if(files != null){
				getLog().info("Loading variables from directory " + variablesFile.getName());
				Arrays.stream(files).forEach(file -> updateContext(context,file));
			}
		} else {
			getLog().info("Loading variables file " + variablesFile.getName());
			updateContext(context,variablesFile);
		}
	}

	private void updateContext(Map<String, Object> context,File file){
		try {
			Yaml yaml = new Yaml();
			context.putAll((Map<String, Object>) yaml.load(FileUtils.readFileToString(file, (Charset) null)));
		}catch (Exception ex){
			throw new IllegalStateException(ex);
		}
	}

	/**
	 * Process the template file.
	 */
	private void processTemplates() {

		// Load template
		File[] templates = templatesDirectory.listFiles();
		if(templates != null){
			Arrays.stream(templates).forEach(template -> {

				getLog().info("Generating properties file from template " + template.getName());

				if(StringUtils.isNotEmpty(profile) && "ALL".equals(profile)){
					//Plugin execution for all profiles
                    File[] variablesDirectories = variablesDirectory.listFiles();
                    if(variablesDirectories != null){
                    	Arrays.stream(variablesDirectories).forEach(vd -> {
							if(vd.isDirectory()){
								getLog().info("Generating properties file from template " + template.getName() + " and variables " + vd.getName());
								File destination = new File(outputDirectory.getPath(),vd.getName());
								renderTemplate(template,vd,destination);
							}
						});
					}
				} else {
					//Plugin execution for specific profile
					renderTemplate(template,variablesDirectory,outputDirectory);
				}
			});
		}
	}



	/**
	 * Render template.
	 * @param template template to process.
	 * @param outputDirectory output directory.
	 */
	private void renderTemplate(File template,File variablesDirectory,File outputDirectory){
		try {

			//
			Jinjava jinjava = new Jinjava();

			//Global context
			Map<String, Object> context = new HashMap<>();

			// Init context
			//Load common variables
			loadVariablesInContext(context,new File(variablesDirectory.getPath(),"common"));

			// Load template specific variable file
			StringBuilder sb = new StringBuilder();
			//Delete .properties.j2
			String fileName = FilenameUtils.removeExtension(FilenameUtils.removeExtension(template.getName()));
			sb.append(fileName).append("-values.yml");
			loadVariablesInContext(context,new File(variablesDirectory.getPath(),sb.toString()));

			// Render and save
			String templateContent = FileUtils.readFileToString(template, (Charset) null);
			String rendered = jinjava.render(templateContent, context);
			File destination = new File(outputDirectory, FilenameUtils.removeExtension(template.getName()));
			FileUtils.writeStringToFile(destination, rendered,
					Charset.forName(encoding));
			getLog().info("Template file " + template.getName() + " processed");

			//Empty context.
			context.clear();

		} catch (Exception ex){
			getLog().info("An exception occurred " + template.getName() + " processed");
			throw new IllegalStateException(ex);
		}
	}
	/**
	 * Validate the plugin configuration.
	 */
	private void validatePluginConfig() {
		//
		if (templatesDirectory != null && (templatesDirectory.isFile() || !templatesDirectory.exists())) {
			throw new IllegalArgumentException(
					"Found bad Configuration: <templatesDirectory> must be set with an existing directory");
		}
		//
		if (variablesDirectory != null && (variablesDirectory.isFile() || !variablesDirectory.exists())) {
			throw new IllegalArgumentException(
					"Found bad Configuration: <variablesDirectory> must be set with an existing directory");
		}
		//
		if ( outputDirectory != null && outputDirectory.isFile() ) {
			throw new IllegalArgumentException(
					"Found bad Configuration: <outputDirectory> must be set with an existing directory");
		}

	}
}
